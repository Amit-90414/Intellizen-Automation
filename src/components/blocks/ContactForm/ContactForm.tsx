import { useEffect, useId, useRef, useState, type ChangeEvent, type FocusEvent, type FormEvent, type KeyboardEvent, type ReactNode } from 'react'
import { Check } from 'lucide-react'
import { Link } from 'react-router'
import { products } from '../../../data/products'
import { copy, site } from '../../../data/site'
import { cx } from '../../../utils/cx'
import { Button } from '../../ui/Button/Button'
import styles from './ContactForm.module.css'

type Values = {
  name: string
  company: string
  phone: string
  email: string
  product: string
  message: string
}

type FieldName = keyof Values
type Errors = Partial<Record<FieldName, string>>
type Status = 'idle' | 'sending' | 'sent' | 'mail' | 'error'
type FieldElement = HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement

const ORDER: FieldName[] = ['name', 'company', 'phone', 'email', 'product', 'message']
const LABELS: Record<FieldName, string> = {
  name: 'Name',
  company: 'Company',
  phone: 'Phone',
  email: 'Email',
  product: 'Interested in',
  message: 'Message',
}
const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/

const endpoint = import.meta.env.VITE_FORM_ENDPOINT?.trim()
const accessKey = import.meta.env.VITE_FORM_ACCESS_KEY?.trim()

function check(field: FieldName, values: Values): string | undefined {
  const value = values[field].trim()
  switch (field) {
    case 'name':
      return value ? undefined : 'Please enter your name.'
    case 'phone':
      return value.replace(/\D/g, '').length >= 10 ? undefined : 'Please enter a phone number with at least 10 digits.'
    case 'email':
      return !value || EMAIL.test(value) ? undefined : 'Please enter a valid email address.'
    case 'message':
      return value ? undefined : 'Please tell us what you want to automate.'
    default:
      return undefined
  }
}

function validate(values: Values) {
  const errors: Errors = {}
  for (const field of ORDER) {
    const message = check(field, values)
    if (message) errors[field] = message
  }
  return errors
}

type FieldShellProps = {
  id: string
  label: string
  required?: boolean
  error?: string
  full?: boolean
  children: ReactNode
}

function FieldShell({ id, label, required, error, full, children }: FieldShellProps) {
  return (
    <div className={cx(styles.field, full && styles.full, error && styles.invalid)}>
      <label htmlFor={id} className={styles.label}>
        {label}
        {required && (
          <span className={styles.required} aria-hidden="true">
            {' '}*
          </span>
        )}
      </label>
      {children}
      {error && (
        <p id={`${id}-error`} className={styles.error}>
          {error}
        </p>
      )}
    </div>
  )
}

export function ContactForm({ defaultProduct = '' }: { defaultProduct?: string }) {
  const uid = useId()
  const empty: Values = { name: '', company: '', phone: '', email: '', product: defaultProduct, message: '' }
  const [values, setValues] = useState<Values>(empty)
  const [errors, setErrors] = useState<Errors>({})
  const [status, setStatus] = useState<Status>('idle')
  const [summary, setSummary] = useState('')
  const [lastDefault, setLastDefault] = useState(defaultProduct)
  const fields = useRef<Partial<Record<FieldName, FieldElement | null>>>({})
  const successRef = useRef<HTMLDivElement>(null)

  if (lastDefault !== defaultProduct) {
    setLastDefault(defaultProduct)
    setValues((current) => ({ ...current, product: defaultProduct }))
  }

  useEffect(() => {
    if (status === 'sent') successRef.current?.focus()
  }, [status])

  const id = (field: FieldName) => `${uid}-${field}`

  const bind = (field: FieldName) => ({
    id: id(field),
    name: field,
    value: values[field],
    ref: (el: FieldElement | null) => {
      fields.current[field] = el
    },
    'aria-invalid': errors[field] ? true : undefined,
    'aria-describedby': errors[field] ? `${id(field)}-error` : undefined,
    onChange: (event: ChangeEvent<FieldElement>) => {
      const next = { ...values, [field]: event.target.value }
      setValues(next)
      if (errors[field]) setErrors((current) => ({ ...current, [field]: check(field, next) }))
    },
    onFocus: (event: FocusEvent<FieldElement>) => {
      if (!window.matchMedia('(max-width: 979px)').matches) return
      const target = event.currentTarget
      window.setTimeout(() => target.scrollIntoView({ block: 'center', behavior: 'smooth' }), 300)
    },
  })

  const goNext = (field: FieldName) => (event: KeyboardEvent<HTMLInputElement>) => {
    if (event.key !== 'Enter' || event.nativeEvent.isComposing) return
    event.preventDefault()
    const next = ORDER[ORDER.indexOf(field) + 1]
    if (next) fields.current[next]?.focus()
  }

  const productName = (slug: string) => {
    if (slug === 'other') return 'Other'
    return products.find((product) => product.slug === slug)?.name ?? ''
  }

  const onSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    if (status === 'sending') return
    const trap = String(new FormData(event.currentTarget).get('website') ?? '')

    const found = validate(values)
    setErrors(found)
    const invalid = ORDER.filter((field) => found[field])
    if (invalid.length > 0) {
      const names = invalid.map((field) => LABELS[field]).join(', ')
      setSummary(`Please check ${invalid.length === 1 ? 'this field' : `these ${invalid.length} fields`}: ${names}.`)
      fields.current[invalid[0]]?.focus()
      return
    }

    setSummary('')
    const interest = productName(values.product)
    const subject = interest ? `${copy.contact.subject} – ${interest}` : copy.contact.subject

    if (!endpoint) {
      const body = [
        `Name: ${values.name}`,
        `Company: ${values.company || '-'}`,
        `Phone: ${values.phone}`,
        `Email: ${values.email || '-'}`,
        `Interested in: ${interest || '-'}`,
        '',
        values.message,
      ].join('\n')
      window.location.href = `mailto:${site.emails[1]}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`
      setStatus('mail')
      return
    }

    setStatus('sending')
    try {
      const response = await fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify({
          ...(accessKey ? { access_key: accessKey } : {}),
          subject,
          name: values.name,
          company: values.company,
          phone: values.phone,
          email: values.email,
          product: interest,
          message: values.message,
          website: trap,
        }),
      })
      if (!response.ok) throw new Error(`Form endpoint returned ${response.status}`)
      setStatus('sent')
      setValues(empty)
    } catch {
      setStatus('error')
    }
  }

  if (status === 'sent') {
    return (
      <div ref={successRef} className={styles.success} role="status" tabIndex={-1}>
        <span className={styles.successIcon}>
          <Check aria-hidden="true" />
        </span>
        <p className={styles.successText}>{copy.contact.success}</p>
        <Button variant="secondary" onClick={() => setStatus('idle')}>
          Send another enquiry
        </Button>
      </div>
    )
  }

  return (
    <form className={styles.form} noValidate onSubmit={onSubmit}>
      <p className={styles.note}>
        Fields marked <span aria-hidden="true">*</span>
        <span className="sr-only">with an asterisk</span> are required.
      </p>

      <div className={styles.summary} aria-live="assertive" role="alert">
        {summary}
      </div>

      <div className={styles.trap} aria-hidden="true">
        <label>
          Website
          <input type="text" name="website" tabIndex={-1} autoComplete="off" />
        </label>
      </div>

      <div className={styles.grid}>
        <FieldShell id={id('name')} label="Name" required error={errors.name}>
          <input {...bind('name')} type="text" autoComplete="name" autoCapitalize="words" enterKeyHint="next" required aria-required="true" onKeyDown={goNext('name')} />
        </FieldShell>

        <FieldShell id={id('company')} label="Company" error={errors.company}>
          <input {...bind('company')} type="text" autoComplete="organization" autoCapitalize="words" enterKeyHint="next" onKeyDown={goNext('company')} />
        </FieldShell>

        <FieldShell id={id('phone')} label="Phone" required error={errors.phone}>
          <input {...bind('phone')} type="tel" inputMode="tel" autoComplete="tel" enterKeyHint="next" required aria-required="true" onKeyDown={goNext('phone')} />
        </FieldShell>

        <FieldShell id={id('email')} label="Email" error={errors.email}>
          <input
            {...bind('email')}
            type="email"
            inputMode="email"
            autoComplete="email"
            autoCapitalize="off"
            spellCheck={false}
            enterKeyHint="next"
            onKeyDown={goNext('email')}
          />
        </FieldShell>

        <FieldShell id={id('product')} label="Interested in" full error={errors.product}>
          <select {...bind('product')}>
            <option value="">Select a product</option>
            {products.map((product) => (
              <option key={product.slug} value={product.slug}>
                {product.name}
              </option>
            ))}
            <option value="other">Other</option>
          </select>
        </FieldShell>

        <FieldShell id={id('message')} label="Message" required full error={errors.message}>
          <textarea {...bind('message')} rows={5} enterKeyHint="enter" required aria-required="true" />
        </FieldShell>
      </div>

      <Button type="submit" block disabled={status === 'sending'} aria-busy={status === 'sending'}>
        {status === 'sending' ? (
          <>
            <span className={styles.spinner} aria-hidden="true" />
            Sending…
          </>
        ) : (
          'Send enquiry'
        )}
      </Button>

      <p className={styles.privacy}>
        By sending this form you agree to our <Link to="/privacy-policy">Privacy Policy</Link>.
      </p>

      <div className={styles.result} aria-live="polite">
        {status === 'error' && <p className={styles.failed}>{copy.contact.error}</p>}
        {status === 'mail' && <p className={styles.mailNote}>{copy.contact.mailOpened}</p>}
      </div>
    </form>
  )
}
